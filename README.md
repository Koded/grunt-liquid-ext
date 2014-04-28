# grunt-liquid-cx

Provides custom extensions for [grunt-liquid](https://github.com/sirlantis/grunt-liquid).  This is a replacement for the fork I did [https://github.com/Koded/grunt-liquid](https://github.com/Koded/grunt-liquid) and allows for easier extensions.

Only mean for internal use.  Use: [grunt-liquid](https://github.com/sirlantis/grunt-liquid).

## Examples

### Adding a filter:

```
Liquid.Template.registerFilter({"t": function (input) {
  return input.toUpperCase();
}});
```

In use:

```
{{ "this is a string" | t }}
```

Outputs:

```
THIS IS A STRING
```

### Adding a Tag:

If in Coffeescript add to `liquid-ext.coffee`.  Otherwise pop in `tasks/liquid_cx.js`.


```
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
```

To pass variables from Grunt to liquid use the following in the Gruntfile:

```
grunt.registerTask('setvars', 'Set variables for Liquid.', function() {
  var vars = grunt.file.readJSON('./models/_global.json');

  grunt.config.set('liquid.options', {
    global: vars
  });
});
```