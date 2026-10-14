describe 'Entorno de pruebas' do
  it 'suma correctamente' do
    expect(1 + 1).to eq(2)
  end
end

describe 'Tests' do
  it 'set_property funciona' do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia,100)
    expect(guerrero.energia).to eq(100)
  end
  it "set_method funciona" do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia,100)
    guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    guerrero.sanar
    expect(guerrero.energia).to eq(110)
  end
  it "set_prototype funciona" do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia,100)
    espadachin = PrototypedObject.new
    espadachin.set_prototype(guerrero)
    espadachin.energia = 100
    guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    espadachin.sanar
    expect(espadachin.energia).to eq(110)
  end
  it "PrototypedConstructor funciona para la creacion a partir de un prototipo" do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia,100)
    Guerrero = PrototypedConstructor.new(guerrero)
    un_guerrero = Guerrero.new({energia:50})
    expect(un_guerrero.energia).to eq(50)

  end
  it "PrototypedConstructor funciona con un proc inicializador" do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_property(:potencial_defensivo, 10)

    constructor_guerrero = PrototypedConstructor.new(guerrero, proc {
      |guerrero_nuevo, una_energia, un_potencial_ofensivo, un_potencial_defensivo|
      guerrero_nuevo.energia = una_energia
      guerrero_nuevo.potencial_ofensivo = un_potencial_ofensivo
      guerrero_nuevo.potencial_defensivo = un_potencial_defensivo
    })

    un_guerrero = constructor_guerrero.new(50, 30, 10)
    expect(un_guerrero.energia).to eq(50)
  end

  it "PrototypedConstructor.copy copia el estado del prototipo" do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_property(:potencial_defensivo, 10)

    constructor_guerrero = PrototypedConstructor.copy(guerrero)

    un_guerrero = constructor_guerrero.new
    expect(un_guerrero.potencial_defensivo).to eq(10)
  end
    it "los métodos agregados a una copia no afectan al prototipo" do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)

    un_guerrero = PrototypedConstructor.copy(guerrero).new
    un_guerrero.set_method(:gritar, proc { "aaah" })

    expect(un_guerrero.gritar).to eq("aaah")
    expect { guerrero.gritar }.to raise_error(NoMethodError)
  end

end
