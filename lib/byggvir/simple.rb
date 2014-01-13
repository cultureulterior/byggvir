require 'byggvir/static'
class ::Object
  class << self
    def method_added(name)
      if name.to_s == File.basename($0,".rb")
        ::Byggvir.wrap(self,self.instance_method(name))
      end
    end
  end
end
