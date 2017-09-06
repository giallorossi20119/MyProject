//
//  Singleton.h
//  IndoGame
//
//  Created by Rainy on 7/2/14.
//
//

#ifndef IndoGame_Singleton_h
#define IndoGame_Singleton_h

template <class T>
class Singleton
{
public:
    static T* getInstance()
    {
        if(!m_p_instance) m_p_instance = new T;
        //assert(m_p_instance != NULL);
        return m_p_instance;
    }
protected:
    Singleton(){};
    ~Singleton(){};
private:
    Singleton(Singleton const&);
    Singleton& operator = (Singleton const&);
    static T* m_p_instance;
};

template <class T> T* Singleton<T>::m_p_instance = 0;//or NULL are the same

#endif /* defined(IndoGame_Singleton_h) */
