class IDE.VMItemView extends NFileItemView

  constructor: (options = {}, data) ->

    options.cssClass or= "vm"

    super options, data

    @vmInfo         = new KDCustomHTMLView
      tagName       : 'span'
      cssClass      : 'vm-info'
      partial       : "#{data.vmName}"

    @terminalButton = new KDButtonView
      cssClass      : 'terminal'
      callback      : =>
        data        = @getData()
        data.treeController.emit 'TerminalRequested', data.vm

    @folderSelector = new KDSelectBox
      selectOptions : @createSelectOptions()
      callback      : @bound 'updateVMRoot'

    @vm = KD.getSingleton 'vmController'
    @vm.on 'StateChanged', @bound 'checkVMState'

    @vm.fetchVMDomains data.vmName, (err, domains) =>
      if not err and domains.length > 0
        @vmInfo.updatePartial domains.first

  updateVMRoot: (path) ->
    data    = @getData()
    vm      = data.vmName
    finder  = data.treeController.getDelegate()

    finder?.updateVMRoot vm, path

  createSelectOptions: ->
    currentPath = @getData().path
    nickname    = KD.nick()
    parents     = []
    nodes       = currentPath.split '/'

    for x in [ 0...nodes.length ]
      nodes = currentPath.split '/'
      path  = nodes.splice(1,x).join '/'
      parents.push "/#{path}"

    parents.reverse()

    items = []

    for path in parents when path
      items.push title: path, value: path

    return items

  pistachio:->
    return """
      <div class="vm-header">
        {{> @vmInfo}}
        <div class="buttons">
          {{> @terminalButton}}
          <span class='chevron'></span>
        </div>
      </div>
      {{> @folderSelector}}
    """
