module.exports =

  activate: (state) ->

    atom.commands.add 'atom-workspace', 'django-wrap-i18n:wrap': => @wrap()

  wrap: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.getSelections().map((item) -> wrapSelection(editor, item))

getPath = () ->
  return atom.workspace.getActivePaneItem()?.buffer.file.getPath()

getExtension = (path) ->
  return path.substr(path.lastIndexOf('.') + 1);

wrapSelection = (editor, selection) ->
  text = selection.getText()
  path = getPath()
  extension = getExtension(path)

  imports = {
    "py": "from django.utils.translation import ugettext_lazy as _",
    "html": "{% load i18n %}",
  }

  #  match bracket
  b = (x) ->
    if x[0] == "\"" && x[x.length-1] == "\"" || x[0] == "\'" && x[x.length-1] == "\'"
      return ""
    return "\""

  functions = {
    "py": (x) -> ['_(', b(x), x, b(x), ')'].join(''),
    "html": (x) -> ['{% trans ', b(x), x, b(x), ' %}'].join(''),
    "js": (x) -> ['gettext(', b(x), x, b(x), ')'].join(''),
    "coffee": (x) -> ['gettext(', b(x), x, b(x), ')'].join(''),
  }
  if text.length > 0
    selection.insertText(functions[extension](text))
  else
    selection.insertText(imports[extension])
