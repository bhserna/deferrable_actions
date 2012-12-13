require_relative '../lib/deferrable_actions'


module DeferrableActions
  class Controller
    include DeferrableActions

    def session
      @session ||= {}
    end
  end
end

describe DeferrableActions do
  let(:controller) { DeferrableActions::Controller.new }

  describe '#defer!' do
    it 'stores the action' do
      DeferrableActions::Action.should_receive(:store).
        with(controller.session, :my_action, arg_one: 'arg_one')
      controller.defer!(:my_action, arg_one: 'arg_one')
    end
  end

  describe '#defered_action?' do
    it 'returns true if a defered action exists' do
      controller.defer!(:my_action, arg_one: 'arg_one')

      DeferrableActions::Action.should_receive(:exists?).with(controller.session)
      controller.defered_action?
    end
  end

  describe '#execute_defered_action!' do
    it 'execute a defered action if the action exists' do
      controller.defer!(:my_action, arg_one: 'arg_one')

      controller.should_receive(:my_action).with arg_one: 'arg_one'
      controller.execute_defered_action!
    end
  end

  describe '#on_failure_execute_defered_action!' do
    it 'execute a defered action if the action exists' do
      controller.defer!(:my_action, arg_one: 'arg_one')

      controller.should_receive(:on_failure_my_action).with arg_one: 'arg_one'
      controller.on_failure_execute_defered_action!
    end
  end
end

module DeferrableActions
  describe Action do
    let(:controller) { Controller.new }

    describe '.store' do
      it 'stores a controller action, with its arguments' do
        Action.store(controller.session, :my_action, arg_one: 'arg_one')

        controller.session[:defered_action].should be_true
        controller.session[:defered_action][:method].should eq :my_action
        controller.session[:defered_action][:args][:arg_one].should eq 'arg_one'
      end
    end

    describe '.exists?' do
      it 'returns true if a defered action exists' do
        Action.store(controller.session, :my_action, arg_one: 'arg_one')

        Action.exists?(controller.session).should be_true
      end
    end

    describe '#execute' do
      it 'executes the deferred action' do
        Action.store(controller.session, :my_action, arg_one: 'arg_one')

        controller.should_receive(:my_action).with arg_one: 'arg_one'
        Action.new(controller).execute!
      end
    end

    describe '#on_failure_execute' do
      it 'executes an action that has an "on_failure_" prefix to the deferred action' do
        Action.store(controller.session, :my_action, arg_one: 'arg_one')

        controller.should_receive(:on_failure_my_action).with arg_one: 'arg_one'
        Action.new(controller).on_failure_execute!
      end
    end
  end
end
