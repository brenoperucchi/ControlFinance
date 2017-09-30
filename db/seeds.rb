# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
store = Store.create(name: 'store 1', language:'pt-BR')
person = store.persons.create(name: 'Admin Person', department:'admin', person_type:'person', active:1)
person.create_user(email: 'admin@email.com', password: 123123)
@broker = store.brokers.create(name: 'Broker', department:'user', person_type:'person', active:1)
@broker.create_user(email: 'test@email.com', password: 123123)

build = store.builds.create(name: 'Build 1')
(1..6).each do |i|
  unit = build.units.create({name: "10#{i}", value: "#{i}50000", size: 55, garage:"#{i}", brokerage:5.5})
  unit.proposals.create(negociate: 'negoaciate', value: "#{i}000", broker:@broker, due_at: Date.today)
end
Proposal.first.update_columns(state:'booked', due_at: Date.today - 1.days)

### Store 2

store = Store.create(name: 'store 2', language:'pt-BR')
person = store.persons.create(name: 'Admin Person 2', department:'admin', person_type:'person', active:1)
person.create_user(email: 'admin2@email.com', password: 123123)
@broker = store.brokers.create(name: 'Broker 2', department:'user', person_type:'person', active:1)
@broker.create_user(email: 'test2@email.com', password: 123123)

build = store.builds.create(name: 'Build 2')
(7..10).each do |i|
  unit = build.units.create({name: "10#{i}", value: "#{i}50000", size: 55, garage:"#{i}", brokerage:5.5})
  unit.proposals.create(negociate: 'negoaciate', value: "#{i}000", broker:@broker, due_at: Date.today)
end
Proposal.first.update_columns(state:'booked', due_at: Date.today - 1.days)