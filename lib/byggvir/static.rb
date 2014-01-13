require 'set'
require 'getoptlong'
require 'yaml'
class Byggvir
  def error!(err)
    $stderr.puts(err);$stderr.flush;Process.exit!(-1);
  end
  def self.wrap(instance,method)
    name = method.name
    arguments = method #map argument types
      .parameters
      .map{|ty, na| [na.to_s, ty]}
      .to_h
    if (badarg = (arguments.values.to_set - [:keyreq, :key].to_set)).empty?
      keyv = { :keyreq => GetoptLong::REQUIRED_ARGUMENT, :key => GetoptLong::OPTIONAL_ARGUMENT }
      short = arguments
        .keys
        .map{|k| {(?- + k[0]) => k}} #prepend dash
        .reduce{|old, new| old.merge(new){|k, o, n| nil}} #duplicates are uncertain
        .select{|k, v| v != nil}
        .invert
      opts = GetoptLong.new(*arguments.map{|k, v| ["--#{k}", short[k], keyv[v]].compact})
      call = {}
      unwrap = proc {|w| (w.class == Array && w.length == 1)?w[0]:w }
      begin
        opts.each{|opt, arg| call[opt[2..-1].to_sym] = unwrap.call(YAML.load("---\n[#{arg}]"))}
      rescue GetoptLong::InvalidOption => ex
        ::Byggvir.error!(ex.to_s)
      else
        instance.send(name,**call)
      end
    else
      ::Byggvir.error("Need a like def(required: ,optional: thing)")
    end
  end
end
