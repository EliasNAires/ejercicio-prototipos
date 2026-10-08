# Acá va el código del TP de prototipos (PrototypedObject, PrototypedConstructor, etc.).

module Prototyped

  def module
    @modulo ||= begin
    nuevo = Module.new
    self.singleton_class.include(nuevo)
    nuevo
  end 
  end

  def set_property(property, value)
    self.module.attr_accessor(property)
    self.send("#{property}=",value)
  end

  def set_method(name,proc)
    self.module.define_method(name,proc)
  end

  def set_prototype(object)
    self.module.include(object.module)
  end
end

class Object
  include Prototyped
end

class PrototypedObject
end