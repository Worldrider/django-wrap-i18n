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

  #  match bracket
  b = (x) ->
    if x[0] == "\"" && x[x.length-1] == "\"" || x[0] == "\'" && x[x.length-1] == "\'"
      return ""
    return "\""

  resolver = {
    "py": (x) -> ['_(', b(x), x, b(x), ')'].join(''),
    "html": (x) -> ['{% trans ', b(x), x, b(x), ' %}'].join(''),
    "js": (x) -> ['gettext(', b(x), x, b(x), ')'].join(''),
    "coffee": (x) -> ['gettext(', b(x), x, b(x), ')'].join(''),
  }
  selection.insertText(resolver[extension](text))
