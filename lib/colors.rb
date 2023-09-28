class String
  def bg_black;        "\e[40m#{self}\e[0m" end
  def bg_white;        "\e[47m#{self}\e[0m" end

  def cyan;           "\e[36m#{self}\e[0m" end
  def red;           "\e[31m#{self}\e[0m" end
end