_ = require "jquery"
$ = require "underscore"

p = require "../../core/properties"

InputWidget = require "./input_widget"
Widget = require "./widget"

multiselecttemplate = require "./multiselecttemplate"


class MultiSelectView extends Widget.View
  tagName: "div"
  template: multiselecttemplate
  events:
    "change select": "change_input"

  initialize: (options) ->
    super(options)
    @render()
    @listenTo(@model, 'change:value', @render_selection)
    @listenTo(@model, 'change:options', @render)
    @listenTo(@model, 'change:name', @render)
    @listenTo(@model, 'change:title', @render)

  render: () ->
    super()
    @$el.empty()
    html = @template(@model.attributes)
    @$el.html(html)
    @render_selection()
    return @

  render_selection: () =>
    values = {}
    _.map(@mget('value'), (x) -> values[x] = true)
    @$('option').each((el) =>
      el = @$(el)
      if values[el.attr('value')]
        el.attr('selected', 'selected')
    )

  change_input: () ->
    @mset('value', @$('select').val())
    @mget('callback')?.execute(@model)

class MultiSelect extends InputWidget.Model
  type: "MultiSelect"
  default_view: MultiSelectView

  @define {
      value:   [ p.Array, [] ]
      options: [ p.Array, [] ]
    }

module.exports =
  Model: MultiSelect
  View: MultiSelectView
