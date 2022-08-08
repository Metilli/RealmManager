# RealmManager

RealmManager is a powerful wrapper to manage realm objects more easly.

## Installation

Swift Package Manager

File > Swift Packages > Add Package Dependency \
Add https://github.com/Metilli/RealmManager.git \
Select "Branch" with "main"

## Configuration

> The default configuration is Realm.Configuration.defaultConfiguration with deleteRealmIfMigrationNeeded property true. So please be careful while using this manager. Your data maybe lost during development.

If you need to migrate your database scheme or disable auto delete the database, you have to do this only one time before using shared realm instance. 

For example:

    var myRealmConfig = Realm.Configuration.defaultConfiguration
    myRealmConfig.deleteRealmIfMigrationNeeded = false
    RealmManager.configuration = myRealmConfig
    
    RealmManager.shared.add(RealmObj) { error in
        print(error.localizedDescription)
    }


## Credits

Thanks Krzysztof Rodak for cascade deleting.
https://gist.github.com/krodak

Thanks Roberto Frontado for detach realm objects.
https://github.com/robertofrontado
