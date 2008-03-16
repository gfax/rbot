#-- vim:sw=2:et
#++
#
# :title: filters management from IRC
#
# Author:: Giuseppe "Oblomov" Bilotta <giuseppe.bilotta@gmail.com>
# Copyright:: (C) 2008 Giuseppe Bilotta
# License:: GPL v2

class FiltersModule < CoreBotModule

  def initialize
    super
    @bot.clear_filters
  end

  def help(plugin, topic="")
    "filters list [<group>] => list filters (in group <group>) | filters search <pat> => list filters matching regexp <pat>"
  end

  def do_list(m, params)
    g = params[:group]
    ar = @bot.filter_names(g).map { |s| s.to_s }.sort!
    if ar.empty?
      if g
        msg = _("no filters in group %{g}") % {:g => g}
      else
        msg = _("no known filters")
      end
    else
      msg = _("known filters: ") << ar.join(", ") 
    end
    m.reply msg
  end

  def do_search(m, params)
    l = @bot.filter_names.map { |s| s.to_s }
    pat = params[:pat].to_s
    sl = l.grep(Regexp.new(pat))
    if sl.empty?
      msg = _("no filters match %{pat}") % { :pat => pat }
    else
      msg = _("filters matching %{pat}: ") % { :pat => pat }
      msg << sl.sort!.join(", ")
    end
    m.reply msg
  end

end

plugin = FiltersModule.new

plugin.map "filters list [:group]", :action => :do_list
plugin.map "filters search *pat", :action => :do_search