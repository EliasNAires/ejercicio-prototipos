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
    self.module.attr_reader(property)
    self.module.define_method("#{property}=") do |valor|
      if valor.is_a?(Proc)
        set_method(property,valor)
      else
        instance_variable_set("@#{property}",valor)
      end
    end
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
        self.instance_exec(&block) if block
    end
end

class PrototypedConstructor

    def initialize(prototipo,aplicar_valores = proc {|objeto,valores|
      valores.each do |clave, valor| 
        objeto.send("#{clave}=",valor)
      end
    }, cantidad_parametros = nil, &bloque)
        @prototipo = prototipo
        @aplicar_valores = aplicar_valores
        @cantidad_parametros = cantidad_parametros || (bloque ? bloque.arity : aplicar_valores.arity - 1)
        @bloque = bloque if bloque
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
      if @bloque
        bloque = @bloque
        cantidad = @cantidad_parametros
        return PrototypedConstructor.new(@prototipo, nil, cantidad + extension.arity) do |*valores|
          instance_exec(*valores.first(cantidad), &bloque)
          instance_exec(*valores.drop(cantidad), &extension)
        end
      end
      cantidad_total = @cantidad_parametros + extension.arity - 1
      PrototypedConstructor.new(@prototipo,proc {|objeto,*valores|
        @aplicar_valores.call(objeto,*(valores.first(@cantidad_parametros)))
        extension.call(objeto,*(valores.drop(@cantidad_parametros)))
      }, cantidad_total)     
    end

    def self.create(&bloque)
        prototipo = PrototypedObject.new(&bloque)
        PrototypedConstructor.copy(prototipo)
    end

    def with(&bloque)
        PrototypedConstructor.new(@prototipo,&bloque)
    end

    def with_properties(claves)
        PrototypedConstructor.new(@prototipo,proc {|objeto,*valores|
        claves.each_with_index do |clave, i| 
        objeto.send("#{clave}=",valores[i])
        end
        }, claves.size)
    end


    def prototype
      @prototipo
    end

    def new(*valores)
      objeto = PrototypedObject.new
      objeto.set_prototype(@prototipo)
      if @bloque
        objeto.instance_exec(*valores, &@bloque)
      else
        @aplicar_valores.call(objeto,*valores)
      end
      objeto
    end

    
end