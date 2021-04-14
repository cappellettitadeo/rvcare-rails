import {GridStack} from "gridstack"
import 'gridstack/dist/h5/gridstack-dd-native'

window.addEventListener('load', function() {
  let dashboard = {
    initializeGridStack() {
      const options = {
        margin: 10,
        animate: true,
        alwaysShowResizeHandle: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
        resizable: { handles: 'e, se, s, sw, w' }
      }

      const grid = GridStack.init(options, '.grid-stack')
      grid.on('change', () => dashboard.saveWidgets())
      grid.on('added', (event, items) => dashboard.addedListener(grid, items))
      grid.on('resizestart', (event, ui) => {
        let overlay = ui.querySelector('.hidden-dialog-overlay')
        if (overlay == null) {
          overlay = document.createElement('div')
          overlay.className = 'hidden-dialog-overlay'
          overlay.style = 'position:absolute;top:0;left:0;right:0;bottom:0;z-order:100000;'

          event.target.appendChild(overlay)
        }
        else {
          overlay.style.display = 'block'
        }
      })

      grid.on('resizestop', (event, ui) => ui.querySelector('.hidden-dialog-overlay').style.display = 'none' );
      dashboard.addedListener(grid, grid.getGridItems())
      this.grid = grid
    },

    addWidgetListener() {
      const grid = this.grid
      const widgetList = document.querySelectorAll('#widget-list a')
      for(let widgetLink of widgetList) {
        widgetLink.addEventListener('click', event => {
          event.preventDefault()
          event.stopPropagation()
          const clickedLink = event.currentTarget
          if (!clickedLink.classList.contains('disabled')) {
            dashboard.addWidget(grid, clickedLink.getAttribute('href'))
            clickedLink.classList.add('disabled')
          }
        })
      }
    },

    addWidget(grid, url){
      $.getJSON(url, function(result) {
        const { settings } = result;
        grid.addWidget({
          x: settings.x_coordinate,
          y: settings.y_coordinate ,
          w: settings.width ,
          h: settings.height,
          content: result.html })
      });
    },

    addedListener(grid, items) {
      for(let item of items) {
        const widget = item.hasOwnProperty('el')? item.el : item
        const closeButton = widget.querySelector('[data-widget-identifier]')
        closeButton.addEventListener('click', function(event) {
          event.preventDefault()
          const widgetIdentifier = event.target.closest('a').dataset.widgetIdentifier
          grid.removeWidget(widget.closest('.grid-stack-item'))
          document.querySelector(`#widget-list a[data-identifier=${widgetIdentifier}]`).classList.remove('disabled')
        })
      }
    },

    widgetSettings(widget) {
      const fields = { x_coordinate: 'gs-x', y_coordinate: 'gs-y', width: 'gs-w', height: 'gs-h'}

      const settings = {}
      Object.keys(fields).map(k => settings[k] = widget.getAttribute(`${fields[k]}`))

      return settings
    },

    allWidgetSettings() {
      const widgets = document.getElementsByClassName('grid-stack-item')
      const result = {}

      for (let widget of widgets) {
        result[widget.querySelector('[data-widget-identifier]').dataset.widgetIdentifier] = dashboard.widgetSettings(widget)
      }
      return result
    },

    saveWidgets() {

      $.ajax({
        type: 'PUT',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        url: '/dashboard',
        data: { dashboard: dashboard.allWidgetSettings() },
        dataType: 'json'
      });
    },
  };

  dashboard.initializeGridStack()
  dashboard.addWidgetListener()
});


