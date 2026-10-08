# TP Prototipos — TADP (UTN FRBA)

Implementación de objetos prototipados en Ruby usando metaprogramación.

## Requisitos

- Ruby (versión en `.ruby-version`)
- Bundler (`gem install bundler` si no lo tenés)

## Instalar dependencias

```bash
bundle install
```

## Correr los tests

Todos los tests:

```bash
bundle exec rspec
```

Un solo archivo:

```bash
bundle exec rspec spec/prototype_spec.rb
```

Un solo test (indicando la línea donde está el `it`):

```bash
bundle exec rspec spec/prototype_spec.rb:2
```

O filtrando por nombre (busca en el texto de `describe`/`it`):

```bash
bundle exec rspec -e "suma correctamente"
```

## Consola interactiva

```bash
bundle exec irb -r ./lib/prototype.rb
```
