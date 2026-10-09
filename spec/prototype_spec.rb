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
  it "PrototypedConstructor funciona" do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia,100)
    Guerrero = PrototypedConstructor.new(guerrero)
    un_guerrero = Guerrero.new({energia:50})
    expect(un_guerrero.energia).to eq(50)

  end




end
