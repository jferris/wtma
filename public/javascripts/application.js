// clear inputs with starter values
PrefilledInput = Class.create({
  initialize:
    function(input) {
      this.input           = $(input);
      this.prefilled_value = input.title;
      this.input.title = '';
      this.observe();
      this.blur();
    },

  focus:
    function() {
      this.input.removeClassName('prefilled');
      if (this.input.value == this.prefilled_value) {
        this.input.value = '';
      }
    },

  blur:
    function() {
      if (this.input.value == '') {
        this.input.value = this.prefilled_value;
        this.input.addClassName('prefilled');
      } else {
        this.input.removeClassName('prefilled');
      }
    },

  observe:
    function() {
      this.input.observe('focus', this.focus.bind(this));
      this.input.observe('blur', this.blur.bind(this));
    }
});

PrefilledInput.submitForm = function(form) {
  form.getElementsBySelector('input.prefilled').each(function(input) {
    input.value = '';
  });
}

PrefilledInput.setup = function() {
  $$('input.prefilled').each(function(input) {
    new PrefilledInput(input);
  });
  $$('form').each(function(form) {
    form.observe('submit', PrefilledInput.submitForm.bind(PrefilledInput, form));
    form.getElementsBySelector('input').each(function(input) {
      if (input.type == 'image' || input.type == 'submit')
        input.observe('click', PrefilledInput.submitForm.bind(PrefilledInput, form));
    });
  });
};

Ajax.Responders.register({ onComplete: PrefilledInput.setup });
Event.observe(document, 'dom:loaded', PrefilledInput.setup);
