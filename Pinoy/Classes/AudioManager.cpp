#include "AudioManager.h"

AudioManager::AudioManager()
{
	m_bMuteEffect = false;
	m_bMuteBackground = false;
}

AudioManager::~AudioManager()
{

}

bool AudioManager::isMuteBackground()
{
	return m_bMuteBackground;
}

bool AudioManager::isMuteEffect()
{
	return m_bMuteEffect;
}

void AudioManager::muteBackground(bool bValue)
{
	m_bMuteBackground = bValue;
	if (bValue)
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
	}
	else
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
	}
}

void AudioManager::muteEffect(bool bValue)
{
	m_bMuteEffect = bValue;
	if (bValue)
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->stopAllEffects();
	}
}

void AudioManager::pauseSoundBackground()
{}
void AudioManager::pauseSoundEffect()
{}
void AudioManager::stopSoundBackground()
{
    if (CocosDenshion::SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying())
    {
        CocosDenshion::SimpleAudioEngine::getInstance()->stopBackgroundMusic();
    }
}

void AudioManager::stopAllSoundEffect()
{
    CocosDenshion::SimpleAudioEngine::getInstance()->stopAllEffects();
}

unsigned int AudioManager::playEffect(const char* pszFilePath, bool bLoop, float pitch, float pan, float gain)
{
	if (m_bMuteEffect) return 0;

	return CocosDenshion::SimpleAudioEngine::getInstance()->playEffect(pszFilePath, bLoop, pitch, pan, gain);
}

void AudioManager::playBackgroundMusic(const char* pszFilePath, bool bLoop)
{
	// ---------------------------------------------------------
	// NORMAL MODE:
	// just play normally	
	if (!m_bMuteBackground)
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->playBackgroundMusic(pszFilePath, bLoop);
		m_sCurBgMusicFile = pszFilePath;
		return;
	}

	// ---------------------------------------------------------
	// MUTE MODE: 
	// do nothing if background music has no change, save if it's the new one
	if (pszFilePath != m_sCurBgMusicFile)
	{
		if (CocosDenshion::SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying())
		{
			CocosDenshion::SimpleAudioEngine::getInstance()->stopBackgroundMusic();
		}
		CocosDenshion::SimpleAudioEngine::getInstance()->playBackgroundMusic(pszFilePath, bLoop);
		CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
		m_sCurBgMusicFile = pszFilePath;
	}
}

void AudioManager::preloadBackgroundMusic(std::string p_sMusicSoundFile)
{
    CocosDenshion::SimpleAudioEngine::getInstance()->preloadBackgroundMusic(p_sMusicSoundFile.c_str());

}
void AudioManager::preloadEffect(std::string p_sEffectSoundFile)
{
    CocosDenshion::SimpleAudioEngine::getInstance()->preloadEffect(p_sEffectSoundFile.c_str());
}
