module.exports =

  activate: (state) ->

    atom.commands.add 'atom-workspace', 'django-wrap-i18n:wrap': => @wrap()

  wrap: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.getSelections().map((item) -> wrapSelection(editor, item))

wrapSelection = (editor, selection) ->
  text = selection.getText()
  path = atom.workspace.getActivePaneItem()?.buffer.file.getPath()
  extension = path.substr(path.lastIndexOf('.') + 1);

  resolver = {
    "py": (x) -> ['_(\"', x, '\")'].join(''),
    "html": (x) -> ['{% trans \"', x, '\" %}'].join(''),
    "js": (x) -> ['gettext(\"', text, '\")'].join(''),
    "coffee": (x) -> ['gettext(\"', text, '\")'].join(''),
  }

  selection.insertText(resolver[extension](text))
