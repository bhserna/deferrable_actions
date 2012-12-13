require "deferrable_actions/version"

module DeferrableActions
  def defer!(method, args)
    Action.store(session, method, args)
  end

  def defered_action?
    Action.exists?(session)
  end

  def execute_defered_action!
    Action.new(self).execute! if defered_action?
  end

  def on_failure_execute_defered_action!
    Action.new(self).on_failure_execute! if defered_action?
  end

  class Action
    attr_reader :controller, :action

    def self.store(session, method, args)
      session[:defered_action] = {
        method: method,
        args: args
      }
    end

    def self.exists?(session)
      !!session[:defered_action]
    end

    def initialize(controller)
      @controller = controller
      @action = controller.session.delete :defered_action
    end

    def execute!
      controller.send(action[:method], action[:args])
    end

    def on_failure_execute!
      controller.send("on_failure_#{action[:method]}", action[:args])
    end
  end
end
