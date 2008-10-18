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
      this.overlay = new GMarker(latlon);
      this.map.addOverlay(this.overlay);
      this.map.setCenter(latlon);
      this.map.setZoom(this.options.zoom);
    },

  removeOverlay:
    function() {
      if (this.overlay) {
        this.map.removeOverlay(this.overlay);
        this.overlay = null;
      }
    }
});
