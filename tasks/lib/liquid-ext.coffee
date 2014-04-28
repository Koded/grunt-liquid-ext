Q = require('q')
module.exports = Liquid = require(__dirname + '/../../node_modules/grunt-liquid/tasks/lib/liquid-ext');

Liquid.Template.registerTag "layout", do ->
  class ExtendsTag extends Liquid.Tag
    Syntax = /([a-z0-9\/\\_-]+)/i
    SyntaxHelp = "Syntax Error in 'extends' - Valid syntax: extends [templateName]"

    constructor: (tagName, markup, tokens, template) ->
      match = Syntax.exec(markup)
      throw new Liquid.SyntaxError(SyntaxHelp) unless match

      template.extends = 'templates/layouts/' + match[1]
      super

    render: (context) ->
      ""


Liquid.Template.registerTag "include", do ->
  class IncludeTag extends Liquid.Tag
    Syntax = /([a-z0-9\/\\_-]+)/i
    SyntaxHelp = "Syntax Error in 'include' - Valid syntax: include [templateName]"

    constructor: (tagName, markup, tokens, template) ->
      match = Syntax.exec(markup)
      throw new Liquid.SyntaxError(SyntaxHelp) unless match
      @filepath = 'templates/includes/' + match[1]
      deferred = Q.defer()
      @included = deferred.promise

      template.importer @filepath, (err, src) ->
        subTemplate = Liquid.Template.extParse src, template.importer
        subTemplate.then (t) -> deferred.resolve t

      super

    render: (context) ->
      @included.then (i) -> i.render context
