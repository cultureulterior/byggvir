require 'set'
require 'getoptlong'
require 'yaml'
class Byggvir
  def self.error!(err)
    $stderr.puts("#{$0}:#{err}");$stderr.flush;Process.exit!(-1);
  end

  # get method parameters as hash
  def self.parameters(method)
    method #map argument types
      .parameters
      .map{|ty, na| [na.to_s, ty]}
      .to_h
  end

  # parse arguments
  def self.interpret(arg)
    data = YAML.load("---\n[#{arg}]")
    data.class == Array && data.length == 1 ? data[0] : data
  end

  # wrap a function
  def self.wrap(instance,method)
    name = method.name
    arguments = ::Byggvir.parameters(method)
    # Check that function has no non-keyword arguments
    if (badarg = (arguments.values.to_set - [:keyreq, :key].to_set)).empty?
      required_arguments = arguments
        .select{|k,v| v == :keyreq}
        .keys
        .map(&:to_sym)
        .to_set
      # Single-letter arguments, first letter, except for duplicates
      short = arguments
        .keys
        .map{|k| {(?- + k[0]) => k}} #prepend dash
        .reduce{|old, new| old.merge(new){|k, o, n| nil}}  #Drop duplicates
        .select{|k, v| v != nil}
        .invert
      opts = GetoptLong.new(*arguments.map{|k, v| ["--#{k}", short[k], GetoptLong::REQUIRED_ARGUMENT].compact})
      opts.quiet = true

      # Use getoptlong to parse arguments,
      call = {}
      begin
        opts.each{|opt, arg| call[opt[2..-1].to_sym] = ::Byggvir.interpret(arg)}
      rescue GetoptLong::InvalidOption => ex
        ::Byggvir.error!(ex.to_s)
      else
        # Call function if all arguments are present
        if (missing_arguments = (required_arguments - call.keys.to_set)).empty?
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
