#ifndef AUDIO_MANAGER_H
#define AUDIO_MANAGER_H

#include "cocos2d.h"
#include "Singleton.h"
#include "SimpleAudioEngine.h"

USING_NS_CC;

class AudioManager : public Singleton<AudioManager>
{
public:
	AudioManager();
	~AudioManager();

	bool isMuteBackground();
	bool isMuteEffect();
	void muteBackground(bool bValue);
	void muteEffect(bool bValue);
    unsigned int playEffect(const char* pszFilePath, bool bLoop = false,
									float pitch = 1.0f, float pan = 0.0f, float gain = 1.0f);
    void playBackgroundMusic(const char* pszFilePath, bool bLoop = false);
    void preloadBackgroundMusic(std::string p_sSoundFile);
    void preloadEffect(std::string p_sSoundFile);
    void pauseSoundBackground();
    void pauseSoundEffect();
    void stopSoundBackground();
    void stopAllSoundEffect();
private:
	std::string m_sCurBgMusicFile;
	bool m_bMuteBackground;
	bool m_bMuteEffect;
};


#endif // !AUDIO_MANAGER_H
