class ContentHandler<T> {
  ArrayList<T> content;
  ArrayList<String> names;
  
  ContentHandler() {
    content = new ArrayList<T>();
    names = new ArrayList<String>();
  }
  
  void asd() {
    
  }
  
  T find(String name) {
    return content.get(findIndex(name));
  }
  
  //obviously needs to address error cases
  int findIndex(String name) {
    for (int i=0; i<names.size(); i++) {
      if (names.get(i).equals(name)) {
        return i;
      }
    }
    return -1;
  }
  
  void delete(String name) {
    int index = findIndex(name);
    content.remove(index);
    names.remove(index);
  }
  
  void add(T object, String name) {
    content.add(object);
    names.add(name);
  }

  //Simulate a function pointer by using an interface.
  //Calling this function is quite ugly: examples can be found in 
  //  
  void load(String filename, String extension, LoadInterface<T> loadInterface) {
    T object = loadInterface.func(filename+"."+extension);
    add(object, filename);
  }
}

interface LoadInterface<T> {
  T func(String arg);
}

