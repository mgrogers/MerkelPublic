var CallIn = function () {

};

CallIn.Conference = Backbone.Model.extend({
    initialize: function() {
        this.fetch();
    },

    sync: function(method, model, options) {
        if (method == 'read') {
            var T = this;
            $.getJSON('/2013-04-23/conference/get/' + this.get("conferenceCode"), function(data, textStatus, jqXHR) {
                T.set(data);
                T.trigger("change");
            });
        }
    }
});

CallIn.ConferenceView = Backbone.View.extend({
    initialize: function() {
        this.render();

        this.model.on("change", this.render, this);
    },

    render: function() {
        data = {
            "title": this.model.get("title"),
            "description": this.model.get("description")
        };

        var template = _.template( $("#conference-template").html(), data);

        this.$el.html( template );
    }
});