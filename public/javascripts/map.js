MapObserver = Class.create({
  initialize:
    function(options) {
      this.options = Object.extend({
        frequency: 0.5,
        zoom:      15
      }, options || {});

      this.map      = this.options.map;
      this.geocoder = this.options.geocoder;
      this.overlay  = null;

      if (this.options.observe)
        this.observeInput($(this.options.observe));
    },

  observeInput:
    function(element) {
     this.input = element;
     new Form.Element.DelayedObserver(
       this.input,
       this.options.frequency,
       this.displayLocationFromInput.bind(this)
     );
    },

  displayLocationFromInput:
    function(element, value) {
      geocoder.getLatLng(value, this.displayLocation.bind(this));
    },

  displayLocation:
    function(latlon) {
      this.removeOverlay();
      if (latlon) {
        this.overlay = new GMarker(latlon);
        this.map.addOverlay(this.overlay);
        this.map.setCenter(latlon);
        this.map.setZoom(this.options.zoom);
      }
    },

  removeOverlay:
    function() {
      if (this.overlay) {
        this.map.removeOverlay(this.overlay);
        this.overlay = null;
      }
    }
});

StoreSelector = Class.create({
  initialize:
    function(options) {
      this.options = Object.extend({
        center:           null,
        resultsContainer: null,
        mapContainer:     null,
        storeUrl:         null,
        nameContainer:    null,
        triggerElement:   null,
        form:             null,
        zoom:             15,
        expanded:         true
      }, options || {});

      this.mapContainer     = $(this.options.mapContainer);
      this.resultsContainer = $(this.options.resultsContainer);
      this.nameContainer    = $(this.options.nameContainer);
      this.form             = $(this.options.form);
      this.triggerElement   = $(this.options.triggerElement);
      this.mapLoaded        = false;

      if (this.options.expanded) {
        this.show();
      } else {
        this.hide(true);
      }

      this.triggerElement.observe('click', this.trigger.bindAsEventListener(this));
    },

  loadMap:
    function() {
      this.mapLoaded = true;
      this.map = new GMap2(this.mapContainer);
      this.map.setCenter(this.options.center, this.options.zoom);

      this.searchControl = new google.maps.LocalSearch({
        resultList:                   this.resultsContainer,
        onGenerateMarkerHtmlCallback: this.markerContents.bind(this)
      });
      this.map.addControl(this.searchControl);
      this.searchControl.focus();
    },

  show:
    function() {
      new Effect.BlindDown(this.form, { 
        afterFinish:
          (function() {
            if (!this.mapLoaded) {
              this.loadMap();
            }
          }).bind(this)
      });
    },

  hide:
    function(quick) {
      if (quick) {
        this.form.hide();
      } else {
        new Effect.BlindUp(this.form);
      }
    },

  markerContents:
    function(marker, element, result) {
      var params = this.parseStoreParams(result);
      element = $(element);
      element.innerHTML = '';

      var title = new Element('div', { 'class': 'gs-title' });
      title.innerHTML = result.titleNoFormatting;
      element.appendChild(title)

      var address = new Element('div', { 'class': 'gs-address' });
      element.appendChild(address);

      var street = new Element('div', { 'class': 'gs-street gs-addressLine' });
      street.innerHTML = result.streetAddress;
      address.appendChild(street);

      var city = new Element('div', { 'class': 'gs-city gs-addressLine' });
      city.innerHTML = result.city + ', ' + result.region;
      address.appendChild(city);

      var country = new Element('div', { 'class': 'gs-country' });
      country.innerHTML = result.country;
      address.appendChild(country);

      var links = new Element('div', { 'class': 'gs-secondary-link' });
      element.appendChild(links);

      var link  = new Element('a', { 'class': 'gs-secondary-link' });
      link.innerHTML = 'Select this store';
      link.observe('click', this.selectStore.bind(this, result.titleNoFormatting, params));
      links.appendChild(link)

      return element;
    },

  selectStore:
    function(name, params) {
      this.nameContainer.innerHTML = name;
      this.nameContainer.addClassName('loading');
      this.nameContainer.show();
      this.form.toggle();

      new Ajax.Request(this.options.storeUrl, {
        method:     'post',
        parameters: params
      });
    },

  parseStoreParams:
    function(result) {
      var full_address = result.streetAddress + ', ' + 
                         result.city + ', ' + 
                         result.region;
      return $H({
        'store[name]':      result.titleNoFormatting,
        'store[location]':  full_address,
        'store[latitude]':  result.lat,
        'store[longitude]': result.lng
      });
    },

  trigger:
    function(e) {
      e.stop();
      if (this.form.visible()) {
        this.hide();
      } else {
        this.show();
      }
    }

});

StoreViewer = Class.create({
  initialize:
    function(options) {
      this.options = Object.extend({
        mapContainer: null,
        stores:       null,
        home:         null,
        zoom:         15
      }, options || {});

      this.mapContainer = $(this.options.mapContainer);
      this.stores       = this.options.stores;
      this.centered     = false;
      this.map          = new GMap2(this.mapContainer);
      this.bounds       = new GLatLngBounds();
      this.nextMarker   = 1;

      this.centerOnStore(this.stores.first());
      this.stores.each(this.addStore.bind(this));

      if (this.options.home) {
        var icon  = new GIcon(G_DEFAULT_ICON, '/images/marker-home.png');
        this.map.addOverlay(new GMarker(this.options.home, icon));
        this.bounds.extend(this.options.home);
      }

      this.map.setZoom(this.map.getBoundsZoomLevel(this.bounds));
      this.map.setCenter(this.bounds.getCenter());

    },

  addStore:
    function(store) {
      var point = new GLatLng(store.latitude, store.longitude);
      var icon  = new GIcon(G_DEFAULT_ICON, '/images/marker' + this.nextMarker + '.png');
      this.map.addOverlay(new GMarker(point, icon));
      this.bounds.extend(point);

      var element = $('store_' + store.id);
      if (element) {
        element.observe('click', this.clickStoreLink.bindAsEventListener(this, store));
      }

      this.nextMarker++;
    },

  clickStoreLink:
    function(e, store) {
      e.stop();
      this.centerOnStore(store);
    },

  centerOnStore:
    function(store) {
      if (this.centered) {
        this.map.setZoom(this.options.zoom);
        this.map.panTo(new GLatLng(store.latitude, store.longitude));
      } else {
        this.map.setCenter(new GLatLng(store.latitude, store.longitude), this.options.zoom);
        this.centered = true;
      }
    }
})
