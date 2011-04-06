Ajax.Autocompleter.Instant = Class.create(Ajax.Autocompleter, {
  initialize: function($super, element, update, url, options) {
    $super(element, update, url, options);
    
    this.options.frequency  = 0;
    this.requesting         = false;
    this.needsUpdate        = false;
  },

  getUpdatedChoices: function($super) {
    if (this.requesting) {
      this.needsUpdate = true;
      return;
    }
    
    this.requesting = true;
    return $super();
  },
  
  onComplete: function($super, request) {
    this.requesting = false;
    
    $super(request);
    
    if (this.needsUpdate) {
      this.needsUpdate = false;
      this.onObserverEvent();
    }
  }
});