def redefine_cancan_abilities
  @ability = Object.new
  @ability.extend(CanCan::Ability)
  allow(@controller).to receive(:current_ability).and_return(@ability)
  @ability.can :manage, :all
end