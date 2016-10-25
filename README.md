# SOLID MVC in Perl

This repository is supplemental material for a presentation by the same name. This presentation discusses [SOLID](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod) and MVC, and [domain-driven](https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) software design principles in the context of a simple Mojolicious Perl application written in 5 different ways.

The premise of the application is a facilities maintenance tracking application, where a user may submit information about a particular item (e.g., a broken light or squeaky door) to create a ticket. Once a ticket is generated, the ticket can be queried to see the new status.

Other aspects of the application such as updating tickets are left as an exercise.

## [maint-v1](maint-v1)

This is a naïve implementation that violates all SOLID principles.

## [maint-v2](maint-v2)

This implementation starts down the path of an ORM, exposing a decidedly data-centric model to the application, rather than a domain model.

## [maint-v3](maint-v3)

This implementation has two data models in the controller, but allows us to begin imagining what a domain model may look like.

## [maint-v4](maint-v4)

This implementation abstracts the domain models, but doesn't quite achieve Single Responsibility or Dependency Inversion.

## [maint-v5](maint-v5)

This implementation has 3 distinct models, each implementing the same interface, allowing us to adhere to Open-Closed and Liskov Substitution principles. The models also use dependency injection following Single Responsibility, Interface Segregation, and Dependency Inversion principles.

The application selects the model at run-time (as does `v4`) with an environment variable:

    MOJO_MODE=memory ./maint-v5 daemon

## [tests](t/model.t)

The test file will run the `maint-v5` version under all three models by setting the `MOJO_MODE` environment variable to `memory`, `flat-file`, or `db`:

    MOJO_MODE=flat-file prove -lv t/model.t

## Summary

In strong OO languages, you get much of this built into the language in the form of templates, interfaces, protocols, or abstract classes. In Perl we have to imagine some of these things and use strong tests to ensure models conform to interfaces.

By using proper domain modeling