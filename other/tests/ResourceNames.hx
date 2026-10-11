// compile with -resource <file>@res : the data of the resource is never read, only its name
class ResourceNames {
    static function main() {
        var names = haxe.Resource.listNames();
        trace(names);
        if( names.length != 1 || names[0] != "res" ) throw "Unexpected resource names " + names;
    }
}
