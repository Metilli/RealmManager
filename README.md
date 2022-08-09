# RealmManager

RealmManager is a powerful wrapper to manage realm objects more easly.

## Installation

Swift Package Manager

File > Swift Packages > Add Package Dependency \
Add https://github.com/Metilli/RealmManager.git \
Select "Branch" with "main"

## Features

- Detach realm objects from realm.
- Cascade deleting.
- Cascade deleting object type and add new object with one function(replaceObject). 
- Reducing the number of code that needs to be written
- Creates new instance for each calls. You don't need to be worry about threads :)

## Configuration

> The default configuration is Realm.Configuration.defaultConfiguration with deleteRealmIfMigrationNeeded property true. So please be careful while using this manager. Your data maybe lost during development.

If you need to migrate your database scheme or disable auto delete the database, you have to do this only one time before using shared realm instance. 

For example:

    let myRealmConfiguration: Realm.Configuration
    
    RealmManager.setup(configuration: myRealmConfiguration)


## Credits

Thanks Roberto Frontado for detach realm objects.
https://github.com/robertofrontado

Thanks Krzysztof Rodak for cascade deleting.
https://github.com/krodak

