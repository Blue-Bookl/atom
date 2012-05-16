{View, $$} = require 'space-pen'
Editor = require 'editor'
fs = require 'fs'
$ = require 'jquery'

module.exports =
class Dialog extends View
  @content: ({prompt} = {}) ->
    @div class: 'tree-view-dialog', =>
      @div prompt, outlet: 'prompt'
      @subview 'miniEditor', new Editor(mini: true)

  initialize: ({path, @onConfirm, select} = {}) ->
    @miniEditor.focus()
    @on 'tree-view:confirm', => @confirm()
    @on 'tree-view:cancel', => @cancel()
    @miniEditor.on 'focusout', => @remove()

    @miniEditor.setText(path)

    if select
      extension = fs.extension(path)
      baseName = fs.base(path)
      range = [[0, path.length - baseName.length], [0, path.length - extension.length]]
      @miniEditor.setSelectionBufferRange(range)

  confirm: ->
    return if @onConfirm(@miniEditor.getText()) is false
    @remove()
    $('#root-view').focus()

  cancel: ->
    @remove()
    $('.tree-view').focus()

  showError: (message) ->
    @prompt.text(message)
    @prompt.flashError()
