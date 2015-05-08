{$, View} = require 'atom-space-pen-views'
{TreeView} = require './tree-view'

module.exports =
class MenuTreeView extends View
  @content : ->
    @section =>
      @h1 outlet : 'title'
      @p 'Double-click item to execute the command.'
      @ul outlet : 'noResults', class : 'background-message centered', =>
        @li 'No Results'

  constructor : (menu, title) ->
    super
    @title.text title
    @noResults.toggle menu.length is 0

    root =
      label : title
      icon : 'icon-file-directory'
      children : []
    root.children.push item for item in menu

    @treeView = new TreeView {useMnemonic:true}
    @append @treeView
    @treeView.setRoot root
    @treeView.onDblClick ({item, node}) =>
      console.log arguments, item.selector
      if item.command and selector = @getActiveElement(item, node)
        if item.created
          item.created.call(item)
        atom.commands.dispatch selector, item.command, item.commandDetail

  getActiveElement: (item, node)->
    console.log(arguments, item.selector, node.parentView?.item?.selector)
    if selector = item.selector
      document.querySelector(selector)
    else if selector = node.parentView?.item?.selector
      document.querySelector(selector)
    else
      # https://github.com/atom/atom/blob/master/src/window-event-handler.coffee#L45-L51
      activeElement = document.activeElement
      # Use the workspace element view if body has focus
      if activeElement is document.body and workspaceElement = atom.views.getView(atom.workspace)
        activeElement = workspaceElement
      activeElement
