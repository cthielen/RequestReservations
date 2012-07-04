(function(){

  function ParameterMissing(message) {
   this.message = message;
  }
  ParameterMissing.prototype = new Error(); 

  var defaults = {
    prefix: '',
    format: ''
  };

  var NodeTypes = {"GROUP":1,"CAT":2,"SYMBOL":3,"OR":4,"STAR":5,"LITERAL":6,"SLASH":7,"DOT":8}
  
  var Utils = {

    serialize: function(obj){
      if (!obj) {return '';}
      if (window.jQuery) {
        var result = window.jQuery.param(obj);
        return !result ? "" : "?" + result
      }
      var s = [];
      for (prop in obj){
        if (obj[prop]) {
          if (obj[prop] instanceof Array) {
            for (var i=0; i < obj[prop].length; i++) {
              key = prop + encodeURIComponent("[]");
              s.push(key + "=" + encodeURIComponent(obj[prop][i].toString()));
            }
          } else {
            s.push(prop + "=" + encodeURIComponent(obj[prop].toString()));
          }
        }
      }
      if (s.length === 0) {
        return '';
      }
      return "?" + s.join('&');
    },

    clean_path: function(path) {
      path = path.split("://");
      last_index = path.length - 1;
      path[last_index] = path[last_index].replace(/\/+/g, "/").replace(/\/$/m, '');
      return path.join("://");
    },

    set_default_format: function(options) {
      if (!options.hasOwnProperty("format") && defaults.format) options.format = defaults.format;
    },

    extract_anchor: function(options) {
      var anchor = options.hasOwnProperty("anchor") ? options.anchor : null;
      delete options.anchor;
      return anchor ? "#" + anchor : "";
    },

    extract_options: function(number_of_params, args) {
      if (args.length > number_of_params) {
        return typeof(args[args.length-1]) == "object" ?  args.pop() : {};
      } else {
        return {};
      }
    },

    path_identifier: function(object) {
      if (!object) {
        return "";
      }
      if (typeof(object) == "object") {
        var property = object.to_param || object.id || object;
        if (typeof(property) == "function") {
          property = property.call(object)
        }
        return property.toString();
      } else {
        return object.toString();
      }
    },

    clone: function (obj) {
      if (null == obj || "object" != typeof obj) return obj;
      var copy = obj.constructor();
      for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
      }
      return copy;
    },

    prepare_parameters: function(required_parameters, actual_parameters, options) {
      var result = this.clone(options) || {};
      for (var i=0; i < required_parameters.length; i++) {
        result[required_parameters[i]] = actual_parameters[i];
      }
      return result;
    },

    build_path: function(required_parameters, optional_parts, route, args) {
      args = Array.prototype.slice.call(args);
      var opts = this.extract_options(required_parameters.length, args);
      if (args.length > required_parameters.length) {
        throw new Error("Too many parameters provided for path");
      }

      parameters = this.prepare_parameters(required_parameters, args, opts);
      if (optional_parts.indexOf('format') != -1) {
        this.set_default_format(parameters);
      }
      var result = Utils.get_prefix();
      var anchor = Utils.extract_anchor(parameters);

      result += this.visit(route, parameters)
      return Utils.clean_path(result + anchor) + Utils.serialize(parameters);
    },

    /*
     * This function is JavaScript impelementation of the
     * Journey::Visitors::Formatter that builds route by given parameters
     * and parsed route binary tree.
     * Binary tree is serialized in the following way:
     * [node type, left node, right node ]
     */
    visit: function(route, options) {
      var type = route[0];
      var left = route[1];
      var right = route[2];
      switch (type) {
        case NodeTypes.GROUP:
          return this.visit_group(left, options)
        case NodeTypes.STAR:
          return this.visit_group(left, options)
        case NodeTypes.CAT:
          return this.visit(left, options) + this.visit(right, options);
        case NodeTypes.SYMBOL:
          var value = options[left];
          if (value) {
            delete options[left];
            return this.path_identifier(value); 
          } else {
            throw new ParameterMissing("Route parameter missing: " + left);
          }
        /*
         * I don't know what is this node type
         * Please send your PR if you do
         */
        //case NodeTypes.OR:
        case NodeTypes.LITERAL:
          return left;
        case NodeTypes.SLASH:
          return left;
        case NodeTypes.DOT:
          return left;
        default:
          throw new Error("Unknown Rails node type");
      }
      
    },

    visit_group: function(left, options) {
      try {
        return this.visit(left, options);
      } catch(e) {
        if (e instanceof ParameterMissing) {
          return "";
        } else {
          throw e;
        }
      }
    },

    get_prefix: function(){
      var prefix = defaults.prefix;

      if( prefix !== "" ){
        prefix = prefix.match('\/$') ? prefix : ( prefix + '/');
      }
      
      return prefix;
    },

    namespace: function (root, namespaceString) {
        var parts = namespaceString ? namespaceString.split('.') : [];
        if (parts.length > 0) {
            current = parts.shift();
            root[current] = root[current] || {};
            Utils.namespace(root[current], parts.join('.'));
        }
    }
  };

  Utils.namespace(window, 'Routes');
  window.Routes = {
// about => /about(.:format)
  about_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"about",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// authorization_rules => /authorization_rules(.:format)
  authorization_rules_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"authorization_rules",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// authorization_usages => /authorization_usages(.:format)
  authorization_usages_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"authorization_usages",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// change_authorization_rules => /authorization_rules/change(.:format)
  change_authorization_rules_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"authorization_rules",false]],[7,"/",false]],[6,"change",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_reservation => /reservations/:id/edit(.:format)
  edit_reservation_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"reservations",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// graph_authorization_rules => /authorization_rules/graph(.:format)
  graph_authorization_rules_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"authorization_rules",false]],[7,"/",false]],[6,"graph",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// logout => /logout(.:format)
  logout_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"logout",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_reservation => /reservations/new(.:format)
  new_reservation_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"reservations",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info_properties => /rails/info/properties(.:format)
  rails_info_properties_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[7,"/",false]],[6,"properties",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// reservation => /reservations/:id(.:format)
  reservation_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"reservations",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// reservation_approve => /reservations/:reservation_id/approve(.:format)
  reservation_approve_path: function(_reservation_id, options) {
  return Utils.build_path(["reservation_id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"reservations",false]],[7,"/",false]],[3,"reservation_id",false]],[7,"/",false]],[6,"approve",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// reservation_deny => /reservations/:reservation_id/deny(.:format)
  reservation_deny_path: function(_reservation_id, options) {
  return Utils.build_path(["reservation_id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"reservations",false]],[7,"/",false]],[3,"reservation_id",false]],[7,"/",false]],[6,"deny",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// reservations => /reservations(.:format)
  reservations_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"reservations",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// root => /
  root_path: function(options) {
  return Utils.build_path([], [], [7,"/",false], arguments);
  },
// suggest_change_authorization_rules => /authorization_rules/suggest_change(.:format)
  suggest_change_authorization_rules_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"authorization_rules",false]],[7,"/",false]],[6,"suggest_change",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// welcome => /welcome(.:format)
  welcome_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"welcome",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  }}
;
  window.Routes.options = defaults;
})();
