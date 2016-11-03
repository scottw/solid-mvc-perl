# SOLID MVC in Perl

This repository contains supplemental material for a [presentation by the same name](http://scottw.github.io/presentations/solid-mvc-perl/). This presentation discusses [SOLID](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod) software design principles and MVC architecture principles, and a few [domain-driven design](https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) principles in the context of a simple Mojolicious Perl application written in 5 different ways.

The premise of the application is a facilities maintenance tracking application, where a user may submit information about a particular item (e.g., a broken light or squeaky door) to create a ticket. Once a ticket is generated, the ticket can be queried to see the new status.

Other aspects of the application such as updating tickets are left as an exercise.

## A note about the implementations

I have included all of the model code necessary to run each example inside the application itself. These models would normally be broken out as separate files and then included dynamically at runtime or installed as part of a build process. Anytime you see an open curly-brace followed by a package declaration, that would be otherwise put into its own file and loaded using `require`.

I should also note that this example was meant to be easy to understand, rather than a good candidate to demonstrate these principles. I didn't want the legibility of the software itself to obscure the design principles; the sacrifice, of course, is that you have to withhold judgement of the principles in this particular case.

An [exploded version](https://github.com/scottw/solid-mvc-perl-supplemental) of `maint-v5` is available, which shows how the model code and `Errr` module might be loaded dynamically, rather than inlined.

## Installing

I use [Carton](https://metacpan.org/release/Carton) or [Carmel](https://metacpan.org/release/Carmel) for build dependencies. I have included a `cpanfile` for your convenience. After install Carmel or Carton, simply:

    $ carton install

or:

    $ carmel install

and you may then run the examples with (substitute `carmel` for `carton` as needed):

    $ MOJO_MODE=memory carton exec -- ./maint-v5 daemon

instead of:

    $ MOJO_MODE=memory ./maint-v5 daemon

## [maint-v1](maint-v1)

This is a naïve implementation that violates all SOLID principles.

## [maint-v2](maint-v2)

This implementation starts down the path of an ORM, exposing a decidedly anemic data-centric model to the application, rather than a domain model.

This mini-ORM implementation has SQL injection vulnerabilities. It was meant to illustrate the architectural concept of a DB model, not necessarily serve as an example of good coding practices. See the [supplemental repo](https://github.com/scottw/solid-mvc-perl-supplemental) for a more hardened ORM.

## [maint-v3](maint-v3)

This implementation has two data models in the controller, but allows us to begin imagining what a domain model may look like.

## [maint-v4](maint-v4)

This implementation abstracts the domain models, but doesn't quite achieve Single Responsibility or Dependency Inversion.

## [maint-v5](maint-v5)

This implementation has 3 distinct models, each implementing the same interface, allowing us to adhere to Liskov Substitution principle. The models also use dependency injection following Single Responsibility, Interface Segregation, and Dependency Inversion principles.

The application selects the model at run-time (as does `v4`) with an environment variable:

    MOJO_MODE=memory ./maint-v5 daemon

## [tests](t/model.t)

The test file will run the `maint-v5` version under all three models by setting the `MOJO_MODE` environment variable to `memory`, `flat-file`, or `db`:

    MOJO_MODE=flat-file prove -lv t/model.t

## Summary

In strong OO languages, you get much of the SOLID benefits built into the language in the form of culture, templates, interfaces, protocols, or abstract classes. In Perl we have to imagine some of these things and use strong tests to ensure models conform to interfaces.

While this particular example doesn't highlight all of the benefits of domain modeling (per *Domain-Driven Design*), it does illustrate most SOLID principles and gives us an inkling why SOLID makes for easier to maintain software, especially for large software systems. MVC architecture and its variants (MVVM, MVP, etc.) are desirable architectural patterns at small scale and large scale.