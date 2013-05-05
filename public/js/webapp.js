var CallIn = function () {

};

CallIn.Conference = Backbone.Model.extend({
    initialize: function() {
        this.fetch();
        this.on("change", this.onChange, this);
        
        Twilio.Device.setup(this.get("token"));
        
        var T = this;

        Twilio.Device.ready(function(device) {
            T.trigger("device:ready");
        });
        Twilio.Device.error(function(error) {
            T.trigger("device:error", {
                error: error
            });
        });
        Twilio.Device.connect(function(conn) {
            T.trigger("device:connect");
        });

        this.on("begin:call", this.beginCall, this);
    },

    sync: function(method, model, options) {
        if (method == 'read') {
            var T = this;
            $.getJSON('/2013-04-23/conference/get/' + this.get("conferenceCode"), function(data, textStatus, jqXHR) {
                T.set(data);
                T.trigger("change");
            });
        }
    },

    onChange: function() {
    
    },

    beginCall: function() {
        this.connection = Twilio.Device.connect({
            conferenceCode: this.get("conferenceCode")
        });
    }
});

CallIn.ConferenceView = Backbone.View.extend({
    initialize: function() {
        this.render();

        this.model.on("change", this.render, this);
        this.model.on("device:ready", this.deviceReady, this);
        this.model.on("device:error", this.deviceError, this);
        this.model.on("device:connect", this.deviceConnect, this);
    },

    render: function() {
        data = {
            "title": this.model.get("title"),
            "description": this.model.get("description")
        };

        var template = _.template( $("#conference-template").html(), data);

        this.$el.html( template );
    },

    deviceReady: function() {
        this.$el.find("#call-status").html('<a href="#" class="btn btn-large btn-primary btn-block" id="call-button">Join</a>');
        var T = this;
        this.$el.find("#call-button").click(function(event) {
            T.call();
        });
    },

    deviceError: function(options) {
        this.$el.find("#call-status").html("Error: " + options.error.message);
    },

    deviceConnect: function() {
        this.$el.find("#call-status").html("Connected");
    },

    call: function() {
        this.model.trigger("begin:call");
    }
});