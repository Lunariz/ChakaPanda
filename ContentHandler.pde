//ContentHandler is a generic class, used to load, store and supply Content, such as images
class ContentHandler<T> {
  ArrayList<T> content;
  ArrayList<String> names;
  
  ContentHandler() {
    content = new ArrayList<T>();
    names = new ArrayList<String>();
  }
  
  //Searches for a piece of content by name
  //TODO: handle "object not found" error from findIndex()
  T find(String name) {
    return content.get(findIndex(name));
  }
  
  //Searches for a piece of content by index
  //TODO: throw "object not found" error instead of returning -1
  int findIndex(String name) {
    for (int i=0; i<names.size(); i++) {
      if (names.get(i).equals(name)) {
        return i;
      }
    }
    return -1;
  }
  
  //Deletes a piece of content, found by name
  //TODO: handle "object not found" error from findIndex()
  void delete(String name) {
    int index = findIndex(name);
    content.remove(index);
    names.remove(index);
  }
  
  //Adds a piece of content
  void add(T object, String name) {
    content.add(object);
    names.add(name);
  }

  //Load a piece of content, by supplying a filename, its extension, and a funcion that will create that piece of content
  //loadInterface simulates a function pointer by using an interface.
  //While calling this function is quite 'ugly' (see GameState.loadImages()), it is also very generic/reusable and extendable
  void load(String filename, String extension, LoadInterface<T> loadInterface) {
    T object = loadInterface.func(filename+"."+extension);
    add(object, filename);
  }
}

//A template interface that is used in ContentHandler.load()
//To call ContentHandler.load(): create a new class using this interface, and supply it as argument
interface LoadInterface<T> {
  T func(String arg);
}

