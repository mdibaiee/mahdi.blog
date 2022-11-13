# Wraps text in .lang-fa div

module Farsi
  class FarsiTag < Liquid::Block
    def render(context)
      text = super
      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
      "<div class='lang-fa'>#{converter.convert(text)}</div>"
    end
  end
end

Liquid::Template.register_tag('fa', Farsi::FarsiTag)
