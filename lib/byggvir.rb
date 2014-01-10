require 'set'
require 'json'
require 'getoptlong'
require 'rdoc/rdoc'
require 'yaml'

class Byggvir
  class << self
    def doc(doc,name)
      instance_method(name).instance_variable_set(:@doc,doc)
    end
    def commands(inst)
      (inst.methods - Object.methods).select{|x| instance_method(x).instance_variable_get(:@doc)}
    end
    def error!(err)
      $stderr.puts(err);$stderr.flush;Process.exit!(-1);
    end
    def new(*args)
      inst=super(*args)
      error!("Please specify a method, One of: #{commands(inst)}") unless ARGV.length>0
      name = ARGV[0].to_sym
      error!("No method #{fun.to_s} defined in #{$0}") unless instance_method(name)
      arguments = instance_method(name).parameters.map{|ty, na| [na.to_s, ty]}.to_h
      ARGV.drop(1)
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
        opts.each{|opt, arg| call[opt[2..-1].to_sym] = unwrap.call(YAML.load("---\n[#{arg}]"))}
        inst.send(name,**call)
      end
    end
  end
end
