require 'byggvir/static'
class Byggvir
  class TestObject
  end
  class Multiple
    class << self
      def doc(doc,name=nil)
        ::Byggvir.error!("doc has to end with a comma, #{caller[1..1]}") unless name.class == Symbol
        @docs||={}
        @docs[name]=doc
      end
      def commands(inst)
        unless @docs
          @docs = (inst.methods.to_set - TestObject.new.methods.to_set).map{|meth|
            [meth,"Options: "+::Byggvir.parameters(inst.instance_eval{self.class.instance_method(meth)}).keys.join(?,)]
          }.to_h
        end
        longest = @docs.keys.map(&:length).max
        @docs.map{ |k,v| Kernel.sprintf("% #{longest+1}s : %s",k,v)}.join("\n")
      end
      def new(*args)
        inst=super(*args)
        ::Byggvir.error!("Please specify a method, One of: \n#{commands(inst)}") unless ARGV.length>0
        name = ARGV[0].to_sym
        ARGV.drop(1)
        begin
          meth = instance_method(name)
        rescue NameError => ex
          ::Byggvir.error!("No method #{name.to_s} defined in #{$0}, try one of \n#{commands(inst)} (#{ex})")
        else
          ::Byggvir.wrap(inst,meth)
        end
      end
    end
  end
end
