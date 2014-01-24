require 'byggvir/static'
class ::Object
  class << self
    # call function if named same as file
    def method_added(name)
      if name.to_s == File.basename($0,".rb")
        ::Byggvir.wrap(self,self.instance_method(name))
      end
    end
  end
end
