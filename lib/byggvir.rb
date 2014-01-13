require 'byggvir/static'
class Byggvir
  class Multiple
    class << self
      def doc(doc,name)
        instance_method(name).instance_variable_set(:@doc,doc)
      end
      def commands(inst)
        (inst.methods - Object.methods).select{|x| instance_method(x).instance_variable_get(:@doc)}
      end
      def new(*args)
        inst=super(*args)
        error!("Please specify a method, One of: #{commands(inst)}") unless ARGV.length>0
        name = ARGV[0].to_sym
        error!("No method #{fun.to_s} defined in #{$0}") unless instance_method(name)
        ARGV.drop(1)
        ::Byggvir.wrap(inst,instance_method(name))
      end
    end
  end
end
