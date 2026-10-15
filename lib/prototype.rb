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

  def method_missing(symbol,*args,&block)
    if symbol.to_s.end_with?('=')
        simbolo = symbol.to_s.chomp('=').to_sym
        if args[0].is_a?(Proc)
            set_method(simbolo,args[0])
        else
            set_property(simbolo,args[0])
        end    
    else
        super
    end
  end

end

class Object
  include Prototyped
end

class PrototypedObject
    def initialize(&block)
        self.instance_exec(&block)
    end
end

class PrototypedConstructor

    def initialize(prototipo,aplicar_valores = proc {|objeto,valores|
      valores.each do |clave, valor| 
        objeto.send("#{clave}=",valor)
      end
    }, cantidad_parametros = aplicar_valores.arity - 1, &bloque)
        @prototipo = prototipo
        @aplicar_valores = aplicar_valores
        @cantidad_parametros = cantidad_parametros
        @bloque = bloque
    end

    def self.copy(prototipo)
      aplicar_valores = proc {|objeto|
        (prototipo.instance_variables - [:@modulo]).each do |variable| 
          objeto.instance_variable_set(variable, prototipo.instance_variable_get(variable))
        end
      }
      self.new(prototipo,aplicar_valores)
    end

    def extended(&extension)
      cantidad_total = @cantidad_parametros + extension.arity - 1
      PrototypedConstructor.new(@prototipo,proc {|objeto,*valores|
        @aplicar_valores.call(objeto,*(valores.first(@cantidad_parametros)))
        extension.call(objeto,*(valores.drop(@cantidad_parametros)))
      }, cantidad_total)     
    end

    def self.create(&bloque)
        prototipo = PrototypedObject.new
        prototipo.instance_exec(&bloque)
        PrototypedConstructor.new(prototipo,nil,0)
    end

    def with(&bloque)
        PrototypedConstructor.new(@prototipo,bloque)
    end

    def with_properties(claves)
        PrototypedConstructor.new(@prototipo,proc {|objeto,*valores|
        i=0
        claves.each do |clave| 
        objeto.send("#{clave}=",valor[i])
        i = i + 1
        end
        })
    end


    def new(*valores)
      objeto = PrototypedObject.new
      objeto.set_prototype(@prototipo)
      @aplicar_valores.call(objeto,*valores)
      objeto.instance_exec(@bloque)
      objeto
    end

    
end