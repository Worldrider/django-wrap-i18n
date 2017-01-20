# django-wrap-i18n package

Wraps selected text in `{% trans "text" %}`, `_("text")` or `gettext("text")` according to file extension.

If no selection - inserts import:

`from django.utils.translation import ugettext_lazy as _`

or

`{% load i18n %}`

## Key bindings

`django-wrap-i18n:wrap`, default `alt-shift-w`: does what you expect
