module NumbersInWords
  module Russian

    def self.canonize(w)
      aliases = {
        "oh" => "zero"
      }
      canon = aliases[w]
      return canon ? canon : w
    end

    def self.exceptions
      {
        0 => "ноль",
        1 => "один",
        2 => "два",
        3 => "три",
        4 => "четыре",
        5 => "пять",
        6 => "шесть",
        7 => "семь",
        8 => "восемь",
        9 => "девять",

        10 => "десять",
        11 => "одиннадцать",
        12 => "двенадцать",

        13 => "тринадцать",
        14 => "четырнадцать",
        15 => "пятнадцать",
        16 => "шестнадцать" ,
        17 => "семнадцать",
        18 => "восемнадцать",
        19 => "девятнадцать",

        20 => "двадцать",
        30 => "тридцать",
        40 => "сорок",
        50 => "пятьдесят",
        60 => "шестьдесят",
        70 => "семьдесят",
        80 => "восемьдесят",
        90 => "девяносто"
      }
    end

    def self.swap_keys hsh
      hsh.inject({}){|h,(k,v)| h[v]=k; h}
    end

    def self.powers_of_ten
      {
        0   => "один",
        1   => "десят",
        2   => "сто",
        3   => "тысяч",
        6   => "миллион",
        9   => "billion",
        12  => "trillion",
        15  => "quadrillion",
        18  => "quintillion",
        21  => "sextillion",
        24  => "septillion",
        27  => "octillion",
        30  => "nonillion",
        33  => "decillion",
        36  => "undecillion",
        39  => "duodecillion",
        42  => "tredecillion",
        45  => "quattuordecillion",
        48  => "quindecillion",
        51  => "sexdecillion",
        54  => "septendecillion",
        57  => "octodecillion",
        60  => "novemdecillion",
        63  => "vigintillion",
        66  => "unvigintillion",
        69  => "duovigintillion",
        72  => "trevigintillion",
        75  => "quattuorvigintillion",
        78  => "quinvigintillion",
        81  => "sexvigintillion",
        84  => "septenvigintillion",
        87  => "octovigintillion",
        90  => "novemvigintillion",
        93  => "trigintillion",
        96  => "untrigintillion",
        99  => "duotrigintillion",
        100 => "googol"
      }
    end

    def self.exceptions_to_i
      swap_keys exceptions
    end

    def self.powers_of_ten_to_i
      swap_keys powers_of_ten
    end

    POWERS_RX = Regexp.union(powers_of_ten.values[1..-1])

    def self.check_mixed(txt)
      mixed = txt.match /^(-?\d+(.\d+)?) (#{POWERS_RX}s?)$/
      if mixed && mixed[1] && mixed[3]
        matches = [mixed[1], mixed[3]].map{ |m| NumbersInWords.in_numbers m }
        return matches.reduce(&:*)
      end
    end

    def self.check_one(txt)
      one = txt.match /^one (#{POWERS_RX})$/
    end

    def self.strip_minus(txt)
      stripped = txt.gsub(/^minus/, "") if txt =~ /^minus/
    end

    def self.check_decimal(txt)
      txt.match(/\spoint\s/)
    end
  end
end
