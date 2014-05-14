class IDEAppController extends AppController

  KD.registerAppClass this,
    name         : "IDE"
    route        : "/:name?/IDE"
    behavior     : "application"
    preCondition :
      condition  : (options, cb)-> cb KD.isLoggedIn()
      failure    : (options, cb)->
        KD.singletons.appManager.open 'IDE', conditionPassed : yes
        KD.showEnforceLoginModal()

  constructor: (options = {}, data) ->
    options.appInfo =
      type          : "application"
      name          : "IDE"

    super options, data

    layoutOptions       =
      direction         : "vertical"
      splitName         : "BaseSplit"
      sizes             : [ "75%", "25%" ]
      views             : [
        {
          type          : "split"
          options       :
            direction   : "vertical"
            sizes       : [ "33%", null]
            colored     : yes
          views         : [
            {
              type      : "custom"
              paneClass : KDView
              partial   : "FILES"
            },
            {
              type      : "custom"
              paneClass : KDView
              partial   : "EDITOR"
            }
          ]
        },
        {
          type          : "custom"
          paneClass     : KDView
          partial       : "CHAT"
        }
      ]

    workspace = new Workspace { layoutOptions }
    workspace.once "ready", => @getView().addSubView workspace.getView()
