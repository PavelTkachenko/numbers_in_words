module NumbersInWords
  module Russian
    class LanguageWriterRussian < LanguageWriter
      delegate :to_i, to: :that

      def initialize that
        super that
        @language = "Russian"
      end

      def negative
        "минус " + NumbersInWords.in_words(-@that)
      end

      def in_words
        v = handle_exception
        return v if v

        in_decimals = decimals
        return in_decimals if in_decimals

        number = to_i

        return negative() if number < 0

        output = if number.to_s.length == 2 #20-99
                   handle_tens(number)
                 else
                   write() #longer numbers
                 end

        output.strip
      end

      def handle_tens(number)
        output = ""

        tens = (number/10).round*10 #write the tens

        output << exceptions[tens] # e.g. eighty

        digit = number - tens       #write the digits

        unless digit == 0
          output << " " + NumbersInWords.in_words(digit)
        end

        output
      end

      def handle_exception
        exceptions[@that] if @that.is_a?(Integer) and exceptions[@that]
      end


      def write
        length = @that.to_s.length
        output =
          if length == 3
            #e.g. 113 splits into "one hundred" and "thirteen"
            write_groups(2)

            #more than one hundred less than one googol
          elsif length < LENGTH_OF_GOOGOL
            write_groups(3)

          elsif length >= LENGTH_OF_GOOGOL
            write_googols
          end
        output.strip
      end

      def decimals
        int, decimals = NumberGroup.new(@that).split_decimals
        if int
          out = NumbersInWords.in_words(int) + " point "
          decimals.each do |decimal|
            out << NumbersInWords.in_words(decimal.to_i) + " "
          end
          out.strip
        end
      end

      private

      def write_googols
        googols, remainder = NumberGroup.new(@that).split_googols
        output = ""

        output << " " + NumbersInWords.in_words(googols) + " googol"
        if remainder > 0
          prefix = " "
          prefix << " " if remainder < 100
          output << prefix + NumbersInWords.in_words(remainder)
        end

        output
      end

      def write_groups group
        #e.g. 113 splits into "one hundred" and "thirteen"
        output = ""
        group_words(group) do |power, name, digits|
          if digits > 0
            prefix = " "
            #no and between thousands and hundreds
            prefix << " " if power == 0  and digits < 100
            output << prefix + NumbersInWords.in_words(digits)
            output << prefix + name unless power == 0
          end
        end
        output
      end
    end
  end
end
