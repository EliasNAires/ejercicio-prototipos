# Acá va el código del TP de prototipos (PrototypedObject, PrototypedConstructor, etc.).

module Prototyped
  def set_property(property, value)
    self.singleton_class.attr_accessor(property)
    self.send("#{property}=",value)
  end
  def set_method(name,proc)
    self.define_singleton_method(name,proc)
  end
end

class Object
  include Prototyped
end

class PrototypedObject
end