# CRP
CRP is a Ruby application which supports small business 
sales data gathering and analysis.

## Functionality
* manage Points of Sales,
* manage users with roles assigned to whole company or particular PoS'es,
* work in PoS context,
* define products, prices, categories, units, etc.,
* add, update and search daily takings,
* **import and parse individual sales receipts from 
electronic copy stored by Novitus cash registers**,
* search, view and display on graphs sales and receipts 
from any day,
* dashboard with summary graphs,
* PL / EN translations.

## Installation
Prerequisites
* Ruby 2.3.1 or later https://www.ruby-lang.org/en/
* Bundler 1.12.5 or later http://bundler.io/
* Git 2.4.9 or later https://git-scm.com/
  
Clone repository
```
$ git clone git@github.com:maciekkolodziej/crp.git
```

Install required gems
```
$ cd crp
$ bundle install
```

Configure database
```
$ vi config/database.yml
```

Create and seed database
```
$ bundle exec rake db:setup
```

Run
```
$ rails s
```

## Usage
Visit ```http://localhost:3000```

Login with ```admin@inevi.pl``` / ```admin```.

Have fun!
