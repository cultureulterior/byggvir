require 'set'
require 'getoptlong'
require 'yaml'
class Byggvir
  def self.error!(err)
    $stderr.puts("#{$0}:#{err}");$stderr.flush;Process.exit!(-1);
  end
  def self.parameters(method)
    method #map argument types
      .parameters
      .map{|ty, na| [na.to_s, ty]}
      .to_h
  end
  def self.wrap(instance,method)
    name = method.name
    arguments = ::Byggvir.parameters(method)
    if (badarg = (arguments.values.to_set - [:keyreq, :key].to_set)).empty?
      required_arguments = arguments.select{|k,v| v == :keyreq}.keys.to_set
      short = arguments
        .keys
        .map{|k| {(?- + k[0]) => k}} #prepend dash
        .reduce{|old, new| old.merge(new){|k, o, n| nil}} #duplicates are uncertain
        .select{|k, v| v != nil}
        .invert
      opts = GetoptLong.new(*arguments.map{|k, v| ["--#{k}", short[k], GetoptLong::REQUIRED_ARGUMENT].compact})
      opts.quiet = true
      call = {}
      unwrap = proc {|w| (w.class == Array && w.length == 1)?w[0]:w }
      begin
        opts.each{|opt, arg| call[opt[2..-1].to_sym] = unwrap.call(YAML.load("---\n[#{arg}]"))}
      rescue GetoptLong::InvalidOption => ex
        ::Byggvir.error!(ex.to_s)
      else
        if (missing_arguments = (required_arguments - call.keys.map(&:to_s).to_set)).empty?
          instance.send(name,**call)
        else
          ::Byggvir.error!("Missing arguments to #{name}: #{missing_arguments.to_a.join(?,)}")
        end
      end
    else
      ::Byggvir.error!("#{name} is not defined correctly, bad arguments #{badarg}\nByggvir can only use optional or mandatory keyword arguments like def(something: other:val)")
    end
  end
end
