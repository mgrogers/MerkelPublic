var CallIn = function () {

};

CallIn.Conference = Backbone.Model.extend({
    initialize: function() {
        this.attendees = new CallIn.AttendeeList([], {
            "conferenceCode": this.get("conferenceCode")
        });

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
        this.on("end:call", this.endCall, this);

        this.attendeesPoller = Backbone.Poller.get(this.attendees, {
            delay: 2000
        });
        this.attendeesPoller.start();
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
    },

    endCall: function() {
        this.connection.disconnect();
        this.trigger("device:disconnect");
    }
});

CallIn.Attendee = Backbone.Model.extend({
    initialize: function() {
    }    
});

CallIn.AttendeeList = Backbone.Collection.extend({
    model: CallIn.Attendee,
    initialize: function(models, options) {
        this.conferenceCode = options.conferenceCode;
    },

    url: function() {
        return "/2013-04-23/conference/get/" + this.conferenceCode + "/attendees";
    }
});

CallIn.ConferenceView = Backbone.View.extend({
    initialize: function() {
        this.render();

        this.model.on("change", this.render, this);
        this.model.on("device:ready", this.deviceReady, this);
        this.model.on("device:error", this.deviceError, this);
        this.model.on("device:connect", this.deviceConnect, this);
        this.model.on("device:disconnect", this.deviceReady, this);
    
        this.model.attendees.on("add", this.addAll, this);
    },

    render: function() {
        data = {
            "title": this.model.get("title"),
            "description": this.model.get("description")
        };

        var template = _.template( $("#conference-template").html(), data);

        this.$el.html( template );

        this.addAll();
    },

    addAttendee: function(attendee) {
        var view = new CallIn.AttendeeView({model: attendee});
        this.$el.find("#attendee-list").append(view.render().el);
    },

    addAll: function() {
        this.$el.find("#attendee-list").html("");
        this.model.attendees.each(this.addAttendee, this);
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
        this.$el.find("#call-status").html('<a href="#" class="btn btn-large btn-error" id="hangup-button">Hang Up</a>');
        var T = this;
        this.$el.find("#hangup-button").click(function(event) {
            T.hangup();
        });
    },

    call: function() {
        this.model.trigger("begin:call");
    },

    hangup: function() {
        this.model.trigger("end:call");
    }
});

CallIn.AttendeeView = Backbone.View.extend({
    tagName: 'li',

    initialize: function() {
        this.render();

        this.model.on("change", this.update, this);
    },

    render: function() {
        data = {
            "displayName": this.model.get("displayName"),
            "email": this.model.get("email")
        }
        var template = _.template( $("#attendee-template").html(), data);

        this.$el.html( template );
        return this;
    },

    update: function() {
        if (this.model.get("status") == "active") {
            this.$el.addClass("attendee-joined");
        } else {
            this.$el.removeClass("attendee-joined");
        }
    }
});